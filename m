From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Thu, 7 Dec 2017 23:40:25 +0000
Message-ID: <5A29D169.4000203@youngman.org.uk>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
 <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de>
 <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
 <CACsGCyTZaqRxWFJ1NxN3jVktRcQv3_AdjRTT+3OfuYMuFYdr_w@mail.gmail.com>
 <20171207135832.GA4858@metamorpher.de> <20171207174048.GA6428@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171207174048.GA6428@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, smartmontools-support@listi.jpberlin.de
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Cross-posting to smartmontools, if any of you could be kind enough to
explain what's happening? Please keep linux-raid and me in the
cross-post as we are not subscribed to smartmontools ...

The command in question is

# smartctl -l scterc,70,70 /dev/sdb ; echo $?

On 07/12/17 17:40, Andreas Klauer wrote:
> On Thu, Dec 07, 2017 at 02:58:32PM +0100, Andreas Klauer wrote:
>> Perhaps it's an intermittent error specific to your smartctl version?
> 
> Looking at the source code, it seems to be a case of:
> 
>     sct supported, erc unsupported - exit 4 (fail)
>     sct unsupported as a whole     - exit 0 (success)
> 
> So some drives will give the wrong exit code for this command.
> 
> Should probably be reported as a bug to smartmontools.
> 
If true, this actually has quite a big impact on hobbyist raid
installations. By default, if a desktop drive hiccups, md-raid will kick
it from the array instead of sorting it out. And there's a script
recommended to fix the problem (changing the linux timeouts) except that
if this is true the script will break.

If we've got a enterprise drive, then the above command works, sets the
timeout to 7 seconds, and returns 0 for success.

For drives like my Barracuda, sct is supported but erc isn't, and I get
4 returned, so the script correctly detects a fail and sets the linux
timeout to 180 seconds.

But if this is true, for a drive that doesn't support sct (I don't have
one to test), the command will fail but return 0!!! So the script
doesn't realise anything is wrong, doesn't fix the defaults, and leaves
the raid array in the dangerous situation where linux will time out long
before the drive does.

So does smartctl return 0 if the drive doesn't support sct? If so why?
And what's the easiest way to detect such a drive if so?

Cheers,
Wolo
