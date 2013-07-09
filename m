From: Curtis <serverascode@gmail.com>
Subject: Re: Determining if a stripe/RAID0 has failed
Date: Tue, 9 Jul 2013 15:52:30 -0600
Message-ID: <CAJ_JamBgpWepch6CjtE_z_LU2P=wrt5Q9hF=QTEoA-zs9kW0nA@mail.gmail.com>
References: <CAJ_JamCpdFHRyYOzEg=yH4k_rv0KnZD8UJ_GwvSrSmHHOSzFAA@mail.gmail.com>
	<20130710074609.37ff918d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130710074609.37ff918d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 9, 2013 at 3:46 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 9 Jul 2013 15:33:29 -0600 Curtis <serverascode@gmail.com> wrote:
>
>> Hi All,
>>
>> I'm wondering what the best way to determine when a RAID0 has failed?
>>
>> We have some stateless servers that use a stripe/RAID0, but we'll need
>> to know if it failed so we can pull it out of the "cluster" and
>> rebuild it. It would be better to find out sooner than later that the
>> stripe has failed.
>>
>> I know from reading the man page that I can't use mdadm to monitor the
>> stripe. Is it basically just that the device becomes unusable in some
>> fashion?
>>
>
> How would you determine if a lone drive had failed?
> Presumably by error messages in the kernel logs, or similar.
> Use exactly the same mechanism to test if a RAID0 has failed.

Ok, that makes total sense, thanks. :)

>
> (A "RAID0" doesn't fail as whole.  Bits of it might, other bits might keep
> working, just like a drive which can lose some sectors but other sectors keep
> working.  Certainly a whole drive can fail if it's logic-board dies.
> Similarly a whole RAID0 can fail if the SATA/SCSI/USB controller dies.)

Noted.

Thanks again,
Curtis.

>
> NeilBrown



--
Twitter: @serverascode
Blog: serverascode.com
