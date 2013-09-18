From: Drew <drew.kay@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Wed, 18 Sep 2013 10:15:42 -0700
Message-ID: <CACJz6QtDt-5mgtpHr092AyFOxoSoY+V7F8QbiUcDuD5JN7TsMA@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
 <CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
 <CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com> <CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 18, 2013 at 8:51 AM, Roberto Spadim <roberto@spadim.com.br> wrote:
> Sorry guys, this time i don't have a full knowledge about the
> workload, but from what he told me, he want fast writes with hdd but i
> could check if small ssd devices could help
> After install linux with raid1 i will install apache mariadb and php
> at this machine, in other words it's a database and web server load,
> but i don't know what size of app and database will run yet
>
> Btw, ssd with bcache or dm cache could help hdd (this must be
> enterprise level) writes, right?
> Any idea what the best method to test what kernel drive could give
> superior performace? I'm thinking about install the bcache, and after
> make a backup and install dm cache and check what's better, any other
> idea?

We still need to know what size datasets are going to be used. And
also given it's a webserver, how big of a pipe does he have?

Given a typical webserver in a colo w/ 10Mbps pipe, I think the
suggested config is overkill. For a webserver the 7200 SATA's should
be able to deliver enough data to keep apache happy.

In the database side, depends on how intensive the workload is. I see
a lot of webservers where the 7200's are just fine because the I/O
demands from the database are low. Blog/CMS systems like wordpress
will be harder on the database but again it depends on how heavy the
access is to the server. How many visitors/hour does he expect to
serve?


-- 
Drew
