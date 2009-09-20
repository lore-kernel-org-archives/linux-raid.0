From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] barrier support for other md/raid levels
Date: Mon, 21 Sep 2009 08:57:05 +1000
Message-ID: <19126.45889.852513.240712@notabene.brown>
References: <19123.9980.940255.937839@notabene.brown>
	<4AB372BA.6020101@redhat.com>
	<4D87015385157D4285D56CA6101072FF26C2CCB1@exchange07.valvesoftware.com>
	<4AB3D148.3060607@redhat.com>
	<87f94c370909181138g197be2fegd4032778ca6d3351@mail.gmail.com>
	<4AB3D4C8.1080602@redhat.com>
	<70ed7c3e0909181318v879ab30h5ffdf8e0b57799b4@mail.gmail.com>
	<b7b14cbb0909201448m37947934r2812ef89146b5b01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Clinton Lee Taylor on Sunday September 20
Sender: linux-raid-owner@vger.kernel.org
To: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday September 20, clintonlee.taylor@gmail.com wrote:
> Greetings ...
> 
> 2009/9/18 Majed B. <majedb@gmail.com>:
> > For what it's worth, I use XFS on one of my arrays, and whenever
> > mounting it, I get this error:
> >
> > [ 2212.567725] Filesystem "dm-0": Disabling barriers, trial barrier write failed
> >
> > So I guess you could use XFS to run your tests.
>  I saw this meesage today, and remember both this thread and that on
> my CentOS 5.4, which I have moved a RAID5/ext4 filesystem from a
> Fedora 10 ...
> 
>  I'm getting these reports in my message log ...
> 
> Sep 19 14:59:52 zeus kernel: JBD: barrier-based sync failed on md5 -
> disabling barriers
> Sep 19 15:06:12 zeus kernel: EXT4-fs: barriers enabled
> 
>  Would this help with testing?

Yes.
There are a number of questions that broad testing testing could help
answer.
 - is the performance impact of this barrier support inline with the
   performance impact of enabling barriers on a single device?
 - are there any unexpected interaction - e.g. does the array ever 
   appear to lock up, either indefinitely or for an extended period of
   time due to usage of barriers?
 - does this barrier support result in a correct ordering of requests
   to media?  i.e. is it actually doing what I mean it to do.

The first two can be tested by regular use of any barrier-enabled
file-system on top of an md array with these patches applied.
The third really requires much more elaborate tests involving randomly
powering off the system and then checking the filesystem for the sort
of inconsistencies that barriers aim to prevent.

So yes, running ext4 (or XFS or ext3 with barriers enabled) on an md
array with barrier support added would help in testing the first two.

I have rebased the relevant patches against 2.6.31 to make it
easier to test them in a clean environment - testing a current
2.6.32-git would be too likely to result in unrelated problems.

So pull from
   git://neil.brown.name/md barriers
to get v2.6.31 plus md barrier support, or download and apply
http://neil.brown.name/git?p=md;a=commitdiff_plain;h=fdc57f371ba0e3c8ce1ac9c0c4586829141531f3
http://neil.brown.name/git?p=md;a=commitdiff_plain;h=3467e61067ccd529e4b27b860a2d6cb29ea80766

Thanks,
NeilBrown
