From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Suboptimal raid6 linear read speed
Date: Wed, 16 Jan 2013 14:29:43 -0600
Message-ID: <50F70DB7.6020104@hardwarefreak.com>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130116025857.GA31112@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/15/2013 8:58 PM, Peter Rabbitson wrote:
> On Tue, Jan 15, 2013 at 08:48:23PM -0600, Stan Hoeppner wrote:
>> With only 4 drives RAID6 doesn't make sense as RAID10 is superior in
>> every way.
> 
> Except raid6 can lose any random 2 drives, while raid10 can't.

This isn't a legitimate argument.  The probability of you being struck
by lightning is greater than two drives in the same mirror in a 4 drive
RAID10 dying before a rebuild completes.

I challenge you to do an exhaustive search for anyone, at any time in
history, who was managing the array properly, suffering such a two drive
failure and losing a RAID10 array, 4 drives or greater.  Note that
controller failures with all drives on one controller don't count, as
that failure mode will take down any array of any RAID level.

-- 
Stan

