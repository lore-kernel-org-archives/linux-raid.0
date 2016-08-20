From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Assistance Reviewing Proposed Recovery Measures
Date: Sat, 20 Aug 2016 11:16:39 +0100
Message-ID: <57B82E07.4080109@youngman.org.uk>
References: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Maxwell <cmaxwell@dal.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/08/16 21:18, Chris Maxwell wrote:
> However, the it also says
> 
>> Recreating should be considered a *last* resort, only to be used when
>> everything else fails. People getting this wrong is one of the primary
>> reasons people lose data. It is very commonly used way too early in
>> the fault finding process. You have been warned! It's better to send
>> an email to the linux-raid mailing list with detailed information
>> (mdadm --examine from all component drives plus log entries from when
>> the failure happened, including mdadm and kernel version) and ask for
>> advice than to try to use --create --assume-clean and getting it wrong.
> 
> 
> 
> So before I messed things up even worse, I figured I would consult the
> experts to see what my next step should be.
> 
Download Phil Turmel's lsdrv. It should be easy to find with google. If
your default Python is 3, just edit the shebang line to make it run.

SAVE THE HARD COPY IN A SAFE PLACE!!!

If anything does go wrong (Sarah's comments about wiping superblocks etc
etc unnerve me) this *should* have all the information you need to
recreate the drives and recover what's recoverable.

(Oh - and the linux raid wiki is a bit of a cobweb site at the moment
:-( so take anything on it with a pinch of salt - it could well be out
of date.)

Also download the latest mdadm from Neil Brown's site. Most distros are
a bit out of date, and the bug fixes might matter.

Cheers,
Wol
