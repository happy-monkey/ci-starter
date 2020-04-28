<?php namespace App\Filters;

use Sentry;
use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

class SentryFilter implements FilterInterface
{
    public function before(RequestInterface $request)
    {
        if( $dsn = getenv('app.sentryDSN') )
        {
            Sentry\init([
                'dsn' => $dsn,
                'environment' => ENVIRONMENT,
            ]);
        }
    }

    /**
     * @inheritDoc
     */
    public function after(RequestInterface $request, ResponseInterface $response)
    {
    }
}