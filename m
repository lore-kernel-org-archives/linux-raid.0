From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/2] add support for launching mdmon via systemd
Date: Fri, 18 Jan 2013 10:09:06 +0100
Message-ID: <wrfjfw1yyi19.fsf@redhat.com>
References: <1358498592-20827-1-git-send-email-Jes.Sorensen@redhat.com>
	<20130118200232.59d328da@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130118200232.59d328da@notabene.brown> (NeilBrown's message of
	"Fri, 18 Jan 2013 20:02:32 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Fri, 18 Jan 2013 09:43:10 +0100 Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Hi,
>> 
>> It's been an ongoing issue for a while trying to figure out how to
>> handle launching mdmon from the initrd in Fedora and avoid it getting
>> killed by systemd due to it ending up in the wrong cgroup (udev).
>> 
>> We tried simply attaching mdmon to the cgroup of systemd but it didn't
>> really work, and in the end it seems to be more in line with the
>> systemd mentality to have systemd spawn it. With these patches and a
>> few pending changes to dracut, I am finally able to boot and reboot
>> systems with 1 or 2 IMSM arrays.
>> 
>> The patch for systemctl is implemented as a compile time option rather
>> than a command line option, since I think it is something that the
>> distro will decide. However we can make it a command line option if
>> preferred.
>> 
>> I also have matching systemd .service files for this, which I am happy
>> to contribute, but I am not sure if they are useful to other distros
>> or not? We haven't had a history of including .service files with
>> mdadm.
>
> Thanks.
> I'll have a proper look next week, however:
>  - I would rather it was a run-time option, not compile time.
>    I believe in giving choice to the admin.
>  - I would like to include the .service files.  I don't know if we can get
>    all distros to use the same one, but we certainly won't if we don't try.

Ok, I'll adapt it as a runtime option and also include the .service
files with the patch.

Cheers,
Jes
