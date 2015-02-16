From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: md_raid5 using 100% CPU and hang with status resync=PENDING, if a drive is removed during initialization
Date: Mon, 16 Feb 2015 15:36:46 -0500
Message-ID: <wrfjpp99pp9d.fsf@redhat.com>
References: <CD8664C5675EDF49A5E76D7DB099D7B32611BB56@VENUS1.in.megatrends.com>
	<20141231164800.GL19091@reaktio.net>
	<CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
	<20150203093040.569aa5e1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203093040.569aa5e1@notabene.brown> (NeilBrown's message of
	"Tue, 3 Feb 2015 09:30:40 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, Pasi =?utf-8?B?S8Okcmtrw6Rp?= =?utf-8?B?bmVu?= <pasik@iki.fi>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Mon, 2 Feb 2015 07:10:14 +0000 Manibalan P <pmanibalan@amiindia.co.in>
> wrote:
>
>> Dear All,
>> 	Any updates on this issue.
>
> Probably the same as:
>
>   http://marc.info/?l=linux-raid&m=142283560704091&w=2

Hi Neil,

I ran some tests on this one against the latest Linus' tree as of today
(1fa185ebcbcefdc5229c783450c9f0439a69f0c1) which I believe includes all
your pending 3.20 patches.

I am able to reproduce Manibalan's hangs on a system with 4 SSDs if I
run fio on top of a device while it is resyncing and I fail one of the
devices.

I can reproduce the issue for raid4 and raid5, but I don't see it if I
I use a raid6.

The following sequence consistently reproduces the problem for me:

mdadm -C /dev/md111 -f -e 1.2 -l5 -n4 /dev/sd[ghij]3
fio --name=md111 --filename=/dev/md111 --thread --numjobs=10 --direct=1 --group_reporting --unlink=0 --loops=1 --offset=0 --randrepeat=1 --norandommap --scramble_buffers=1 --stonewall --rw=randwrite --bs=8704 --iodepth=4000 --runtime=3000 --blockalign=512
mdadm /dev/md111 -f /dev/sdg3

Cheers,
Jes
