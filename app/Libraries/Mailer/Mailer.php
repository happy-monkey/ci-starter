<?php namespace App\Libraries\Mailer;

use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;

class Mailer
{
    static $defaultLightColor   = '#f6f6f6';
    static $defaultPrimaryColor = '#3498db';

    /**
     * @var PHPMailer
     */
    protected $email;

    protected $fromName = '';
    protected $fromEmail = '';

    protected $html = true;
    protected $subject = '';
    protected $body = '';
    protected $args = [];

    static function create( $subject, $body, $args = [] ): Mailer
    {
        $email = new Mailer();
        $email->setSubject($subject);
        $email->setBody($body, $args);
        return $email;
    }

    protected function prepareEmail()
    {
        $this->email->Subject = $this->subject;
        $this->email->isHTML($this->html);

        $template = APPPATH . 'Views' . DS . $this->body . '.php';

        if ( file_exists($template ) )
        {
            $this->email->Body = view($this->body, array_merge([
                'color_light'   => self::$defaultLightColor,
                'color_primary' => self::$defaultPrimaryColor,
                'pre_header'    => '',
            ], $this->args));
        }
        else
        {
            $this->email->Body = $this->body;
        }
    }

    public function setSubject( $subject ): Mailer
    {
        $this->subject = $subject;
        return $this;
    }

    public function setBody( $view, $args = [] ): Mailer
    {
        $this->body = $view;
        $this->args = $args;
        return $this;
    }

    public function __construct()
    {
        $config = config('email');

        $this->email = new PHPMailer(false);

        $this->email->isSMTP();
        $this->email->Host       = $config->SMTPHost;
        $this->email->SMTPAuth   = true;
        $this->email->Username   = $config->SMTPUser;
        $this->email->Password   = $config->SMTPPass;
        $this->email->Port       = $config->SMTPPort;
        $this->email->SMTPSecure = $config->SMTPCrypto;
        $this->email->CharSet    = $config->charset;

        $this->setFrom($config->fromEmail, $config->fromName);
    }

    public function setFrom( $email, $name = '' ): Mailer
    {
        $this->fromEmail = $email;
        $this->fromName = $name;
        return $this;
    }

    public function setReplyTo( $email, $name = '' ): Mailer
    {
        $this->setReplyTo($email, $name);
        return $this;
    }

    /**
     * @param Recipient[]|Recipient|string[]|string $to
     * @param string $name
     * @return $this
     * @throws Exception
     */
    public function addRecipient($to, string $name = '' ): Mailer
    {
        if ( is_array($to) )
        {
            foreach( $to as $item )
                $this->addRecipient($item);
        }
        if ( is_a($to, Recipient::class) )
        {
            $this->email->addAddress($to->email, $to->name);
        }
        else
        {
            $this->email->addAddress($to, $name);
        }

        return $this;
    }

    public function send( $recipients = null, $reset = true ): bool
    {
        if ( $this->email )
        {
            try {
                if ( !is_null($recipients) )
                    $this->addRecipient($recipients);

                $this->prepareEmail();
                $this->email->setFrom($this->fromEmail, $this->fromName);
                $result = $this->email->send();
                $this->email->clearAddresses();

                if ( $reset )
                    $this->email = null;

                return $result;
            } catch ( \Exception $exception ) {
            }
        }

        return false;
    }
}