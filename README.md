# GitFeeds

GitFeeds is a little Rails app which provides a granular RSS interface to any Git repo. I created it to keep track of the busy repos which I'm interested in (e.g. Rails, Django) without having to watch them on GitHub. Unlike the few other Git-to-RSS solutions which I could find, GitFeeds provides a variety of ways of subscribing to a repo:

* Every commit
* New releases (tags)
* Commits batched by week

Okay, so not _a variety_ quite yet, but it's getting there.


## Requirements

* [Git](http://git-scm.com)
* [Redis](http://redis.io)


## Deploying

See [DEPLOYME.md](https://github.com/adammck/gitfeeds/blob/master/DEPLOYME.md) for instructions to deploy this thing in production.


## License

GitFeeds.com is free software, available under the MIT license.
