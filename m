From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Manually reconstruct a RAID10 from adaptec 3805
Date: Tue, 21 Jan 2014 01:15:44 -0600
Message-ID: <52DE1EA0.8060403@hardwarefreak.com>
References: <CAE6VuKFnEjPsq=aeQXU4Jfn_3kD1TE19gRGk3YGdUXGTdgN+xg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE6VuKFnEjPsq=aeQXU4Jfn_3kD1TE19gRGk3YGdUXGTdgN+xg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raul Dias <raul@dias.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/20/2014 2:01 PM, Raul Dias wrote:
> Hello,
> 
> I have a failled RAID 10 in a remote server.  The controller show all
> drives as "offline"
> In order to recover it, I will try to reconstruct the fs from disk images.
> 
> Does anyone have a clue on how adaptec layouts its raid10 disks?
> 
> So far, all information I have is this:
> http://www.unixwiz.net/techtips/recovering-failed-raid.html
> 
> However, it is from 2008 and a raid1 only.
> Can anyone point me in the right direction?

Apparently you've performed many additional troubleshooting steps but
omitted them here.  The path you suggest is only taken when a RAID
controller has failed and a same brand replacement unit is not possible.

Simply having all drives kicked offline doesn't mean the controller has
failed.  Usually it means all drives lost power, or there is a problem
with the backplane.

Please describe what happened before the drives went offline.  Did the
server crash?  Lose power?  Or did all 4,6,8 drives mysteriously just go
offline?  How many drives in this RAID10 array?

The first thing you should do in such a circumstance is boot the machine
and enter the RAID BIOS, then manually force all the drives online, then
perform a health check (whatever Adaptec calls this) of the array.  If
everything passes, boot up the machine.

If any or all of the drives are booted offline again, you need to
inspect the hardware, specifically the power feed to the backplane, the
backplane itself, and the PSU.

Trying to manually reconstruct the data from the drives is an absolute
last resort, when the controller is verified to have failed, and a
replacement isn't available.

-- 
Stan

