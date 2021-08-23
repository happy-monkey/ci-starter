<?php namespace Config;

use App\Filters\SentryFilter;
use CodeIgniter\Config\BaseConfig;
use Fluent\Cors\Filters\CorsFilter;

class Filters extends BaseConfig
{
	// Makes reading things below nicer,
	// and simpler to change out script that's used.
	public $aliases = [
		'csrf'     => \CodeIgniter\Filters\CSRF::class,
		'toolbar'  => \CodeIgniter\Filters\DebugToolbar::class,
		'honeypot' => \CodeIgniter\Filters\Honeypot::class,
        'cors'     => CorsFilter::class,
        'sentry'   => SentryFilter::class,
	];

	// Always applied before every request
	public $globals = [
		'before' => [
		    'cors',
		    'sentry',
			//'honeypot'
			// 'csrf',
		],
		'after'  => [
		    'cors',
			'toolbar',
			//'honeypot'
		],
	];

	// Works on all of a particular HTTP method
	// (GET, POST, etc) as BEFORE filters only
	//     like: 'post' => ['CSRF', 'throttle'],
	public $methods = [];

	// List filter aliases and any before/after uri patterns
	// that they should run on, like:
	//    'isLoggedIn' => ['before' => ['account/*', 'profiles/*']],
	public $filters = [];
}
