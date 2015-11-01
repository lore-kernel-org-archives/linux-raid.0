From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Sun, 1 Nov 2015 15:55:15 -0500
Message-ID: <56367C33.6060703@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dee,

On 10/31/2015 07:55 AM, o1bigtenor wrote:
> Greetings
> 
> I had a raid 10 array where one drive threw an error (seemingly in a
> superblock) and since I have not been able to get the array readable.
> It was suggested to me that I remove 2 of the drives leaving the two
> that were striped together.

[trim /]

What happened to the other two drives?  If you still have them, please
supply "mdadm -E" report for them.

Also supply "smartctl -i -A -l scterc /dev/sdX" for each of your drives.

> Is there some way to take the 2 drives and convince mdadm that they
> are a raid 0?

Shouldn't be necessary.  Whatever parts of your array that can be made
to run as originally is the safest way to proceed.  Also, you haven't
provided any information about your original problem that suggests you
received good advice.  (Probably not.)

You attempted a number of commands with invalid bracket syntax, so
received file not found errors that you ignored.  You also attempted
filesystem diagnostics on md0 while it was inactive -- that's why those
failed.

You also attempted some operations after partial successes.  When an
array is partially assembled but not running, before further attempts to
assemble you must stop the array:

mdadm --stop /dev/md0

Before I suggest anything else, I'd like to see the complete reports for
all four drives.

Please don't do anything else.  Your report suggests you are trying
things almost at random in a desperate attempt to salvage your data.
Slow down.  We can help if you don't ruin things in the meantime.

Phil
