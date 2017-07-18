From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 3-disk fail on raid-6, examining my options...
Date: Tue, 18 Jul 2017 21:20:02 +0100
Message-ID: <596E6D72.8050108@youngman.org.uk>
References: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/07/17 18:20, Maarten wrote:
> Now from what I've gathered over the years and from earlier incidents, I
> have now 1 (one) chance left to rescue data off this array; by hopefully
> cloning the bad 3rd-failed drive with the aid of dd_rescue and
> re-assembling --force the fully-degraded array. (Only IF that drive is
> still responsive and can be cloned)

If it clones successfully, great. If it clones, but with badblocks, I
keep on asking - is there any way we can work together to turn
dd-rescue's log into a utility that will flag failed blocks as "unreadable"?

This project is mentioned on the wiki, the idea being that you can tell
the hard drive to return a read error if the computer tries to access
certain blocks. This "fake" read error means that we can then use a
partially copied disk to rebuild an array knowing that we will get an
error rather than silent corruption if we try and access the faulty block.

At least then, we know what is damaged rather than trying to
integrity-check an entire disk in the hope that we'll detect the corruption.

Cheers,
Wol
