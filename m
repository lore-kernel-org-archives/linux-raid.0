From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Wed, 27 Mar 2013 14:36:52 -0500
Message-ID: <51534A54.4040301@hardwarefreak.com>
References: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com> <16639206.20.1364400094382.JavaMail.root@zimbra> <CAFCYAsfWTC+Yjkh-XO89M44bxt_7cjBB6kT+xdEfrr4L9QPZRw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAsfWTC+Yjkh-XO89M44bxt_7cjBB6kT+xdEfrr4L9QPZRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/27/2013 11:23 AM, Jeff Johnson wrote:

>       bitmap: 3/3 pages [12KB], 65536KB chunk

The above has ZERO to do with what you report below.

> It is very strange. the responsiveness on small file i/o tends to
> support the notion that this mirror really has a 64MB chunk size. This

No it doesn't.  You lack understanding of how disk mirroring works.

> is practically an order of magnitude larger than what is prudent. The
> iowait on simple things like a sync or writing out small files seems
> to support what mdstat is reporting. Of course, I'd like to change
> this but how to do so without breaking the RAID or risking data is not
> obvious.

The IO latency you describe is unrelated to md.  It is most often caused
by filesystem free space fragmentation.  How full is the filesystem in
question?  If over 90 percent odds are good that this is your problem.
If it's an XFS filesystem I can give you commands to show the free space
map, which will answer the question definitively.  If EXTx you're on
your own as I don't know the tools (if they exist).

This IO latency can also be caused if hardware (disk/controller) is
malfunctioning.  Look at 'smartctl -A' output for both drives.

-- 
Stan

