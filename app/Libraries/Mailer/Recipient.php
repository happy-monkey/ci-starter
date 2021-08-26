<?php namespace App\Libraries\Mailer;

class Recipient
{
    public $email = '';
    public $name = '';

    public function __construct( $email, $name = '' )
    {
        $this->email = $email;
        $this->name = $name;
    }
}