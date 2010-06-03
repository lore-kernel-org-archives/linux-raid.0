From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: devices get kicked from RAID about once a month
Date: Thu, 03 Jun 2010 13:00:33 -0400
Message-ID: <4C07DFB1.4060006@tmr.com>
References: <4C06A31A.4060907@gmx.net> <20100603101359.01f61d0d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100603101359.01f61d0d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: st0ff@npl.de, st0ff@gmx.net, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wed, 02 Jun 2010 20:29:46 +0200
> Stefan /*St0fF*/ H=C3=BCbner <st0ff@gmx.net> wrote:
>
>  =20
>>> Any other suggestions? =20
>>>      =20
>> Not really, it's up to Neil to export some sysfs-variable, where you
>> could tune how long a drive may take to respond to some command.
>>
>>    =20
>
> Nope.  md doesn't do any timeouts.
>  =20

That's the problem. A timeout between getting the timeout status and=20
trying the rewrite is really needed to have any hope of recovery.

If there were a write intent bitmap for the drive, perhaps the drive=20
could enter some "may be recovering" state and writes, including the on=
e=20
to rewrite the sector, could be help off for some few minutes. I say=20
that, knowing that there is at least some similar code working for=20
network attached drives, which seem to survive a brief network issue.

Telling the user a write intent bitmap is needed and making use of it=20
sound at all practical as a use for some existing code?

> You need to look for, or ask for, such variables at the scsi/sata lay=
er.
>
>  =20
The need for a delay between timeout and rewrite

--=20
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
