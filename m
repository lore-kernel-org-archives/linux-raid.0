From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 16:43:10 -0500
Message-ID: <4FAC366E.7080309@hardwarefreak.com>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/10/2012 10:26 AM, Marcus Sorensen wrote:

> * Using smartctl to increase the ERC timeout on enterprise SATA
> drives, say to 25 seconds, for use with md. I have no idea if this
> will cause the drive to actually try different methods of recovery,
> but it could be a good middle ground.

If a drive needs 25 seconds to recover from a read error it should have
been replaced long ago.

The only thing that increasing these timeouts to silly high numbers does
is, hopefully for those doing it anyway, prolong the replacement
interval of failing drives.

Can anyone guess what the big bear trap is that this places before you?
 The rest of the drives in the array have been held over much longer as
well.  So when you go to finally rebuild the replacement for this 25s
delay king, you'll be more likely to run into unrecoverable errors on
other array members.  Then you chance losing your entire array, and, for
many here, all of your data, as hobbyists don't do backups. ;)

Fist 2 rules of managing RAID systems:

1.  Monitor drives and preemptively replace those going down hill BEFORE
your RAID controllers or md raid kick them

1a. Don't wait for controllers/md raid to kick bad drives

2.  Data is always worth more than disks drives

2a. If drives cost more than your lost data, you're doing it wrong

-- 
Stan
