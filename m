From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Tue, 04 Nov 2014 11:17:46 -0500
Message-ID: <5458FC2A.1050308@turmel.org>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20141103T151703-83@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Vince,

On 11/03/2014 09:45 AM, Vince wrote:
> Phil Turmel <philip <at> turmel.org> writes:

[trim /]

>> You haven't (yet) lost your array.  It's just degraded.  You should
>> investigate why the one drive was kicked out of the array instead of
>> being rewritten properly (green drives?).  In the meantime, assembly
>> with --force should give you access to the data to grab anything
>> critically important.

[trim /]

> Hi Phil,
>
> thx for your reply.
> Already have the raid clean and up.

Very good to hear you haven't lost your data.

> My drive was kicked due to read errors (bad sectors).
> I fixed the bad sectors with hdparm --write-sector $bad_sector /dev/sdx

This is a problem you haven't solved yet, I think.  The raid array 
should have fixed this bad sector for you without kicking the drive out. 
  The scenario is common with "green" drives and/or consumer-grade 
drives in general.

If you want to be sure your array is safe for the future, you should 
search this list's archives for "timeout mismatch", "scterc", and/or 
"URE".  Then you can set up your array to properly correct bad sectors, 
and set your system to look for bad sectors on a regular basis.

Phil
