From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: mdadm vs zfs for home server?
Date: Tue, 28 May 2013 00:12:23 -0500
Message-ID: <51A43CB7.1090603@hardwarefreak.com>
References: <20130527180912.GA6068@septictank.raw-sewage.fake> <51A3DF2B.7070200@hardwarefreak.com> <51A3F141.9050505@turmel.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51A3F141.9050505@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/27/2013 6:50 PM, Phil Turmel wrote:
> Hi all,
> 
> On 05/27/2013 06:33 PM, Stan Hoeppner wrote:
> 
> [trim /]
> 
>> WRT to scheduled scrubbing, I don't do it, I don't believe in it.  While
>> it may give you some piece of mind, this simply puts extra wear on the
>> drives.  RAID6 it is self healing, right, so why bother with scrubbing?
>>  It's a self fulfilling prophecy kinda thing--the more you scrub, the
>> more likely you are to need to scrub due to the wear of previous scrubs.
>>  I don't do it any arrays.  It just wears the drives out quicker.
> 
> I'm going to go out on a limb here and disagree with Stan.  I do "check"
> scrubs in lieu of SMART long self tests, on a weekly basis.  They both
> read the entire drive--necessary to uncover "pending" sectors.  But a
> check scrub will rewrite that pending sector to immediately turn it into
> a relocation, if it cannot be fixed.  An enterprise drive's better error
> rate (an order of magnitude better, from the specs I've read) reduces
> the need to do any scrub, but if you are doing long self tests anyways,
> you should scrub.
...

I should have qualified my statement above because as with many IO
related things, "to scrub or not to scrub" depends largely on one's
workload as well as the quality of the drives.  If one treats an array
of WDEARS drives as a WORM device, such as in the home media server
case, scrubbing may not be a bad idea as surface defects may develop and
never be discovered until "it's too late".

At the other end of the spectrum we have a busy SMTP/POP server with an
array of Seagate SAS drives w/XFS atop and running at average ~70% of
storage capacity.  It is going to see write/read/delete cycles daily
across nearly the entire array "surface".  In this case the application
itself is performing the "scrubbing", albeit not every sector of every
drive.  But this isn't necessary, as over a period of a week or so most
sectors will be overwritten.  Now, if such a system runs at 70% of peak
IOPS capacity 24x7, running a scrub may take days to complete, and will
invariably slow down user IO, no matter how it's prioritized.  And at
this high a duty cycle the drives are sustaining wear at a good clip
already.  Running scheduled scrubs, again, simply puts more wear on the
drives.  So in this case it doesn't make a lot of sense to do scheduled
scrubs.

And of course there are all kinds of workloads and hardware quality
combinations in between.  This is why I spoke from first person up
above, stating what -I- do.  Most of the advice I give to others on this
list is formulated as "this is what -you- should do".  I won't do that
with this subject because there's too much variability.

What people should gain from this sub topic of this thread is that
scheduled scrubbing is neither statically good nor bad, but that, as
with many things IO related, it "depends".

-- 
Stan

