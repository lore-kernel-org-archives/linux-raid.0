From: Luca Berra <bluca@comedia.it>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 07:17:27 +0100
Message-ID: <20081028061727.GA7764@percy.comedia.it>
References: <18692.62860.863118.727187@notabene.brown> <20081027082257.GB1801@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081027082257.GB1801@piper.oerlikon.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 09:22:57AM +0100, martin f krafft wrote:
>also sprach Neil Brown <neilb@suse.de> [2008.10.26.2356 +0100]:
>> Greeting.
>>  This is a Request For Comments....
>
>Good morning!
>
>[...]
>> I'm also wondering if I should include a udev 'rules' file for md
>> in the mdadm distribution.  Obviously it would be no more than
>> a recommendation, but it might give me a voice in guiding how udev
>> interacted with mdadm.
>
>I would really like to have a clear separation of competencies.
>Ideally, mdadm never creates any devices but leaves it all to udev,
>and all configuration about alternate names ("symlinks") is done in
>the udev rules file.
I would not, mdadm should be still able to create the base device name
if needed. Aliases could be left to udev.
>I know mdadm needs the devices for the ioctls(). However, much of
>what it does with ioctl should already be possible with /sys. Thus,
>in my ideal world, I imagine mdadm to be a manipulator of /sys,
/sys has the same issue as /dev.
there is no md sys node before the device is created.
apart from this small issue, mdadm should be able to control md via
sysfs as well (i.e. sync_action).

>I realise this would require a revamp of mdadm, and might actually
>be better done in a new software designed to eventually replace
>mdadm. But is this a way forward with which you could befriend
>yourself?
Please, NO, it took ages to get people and some distributions to stop
using raidtools in favor of mdadm, don't do this mess again.

L.



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
