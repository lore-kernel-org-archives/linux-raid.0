From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: In Trouble--Please Help! (was Re: Can't add disk to failed raid
 array)
Date: Tue, 25 Jul 2006 10:27:05 -0400
Message-ID: <44C62A39.2040906@waldoware.com>
References: <200607152056.55090.pwaldo@waldoware.com>	 <200607230753.47853.pwaldo@waldoware.com>	 <17603.25777.274507.385333@cse.unsw.edu.au>	 <200607230832.48807.pwaldo@waldoware.com> <e9c3a7c20607241126n614b7941i4319a7889ac12c5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20607241126n614b7941i4319a7889ac12c5e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> On 7/23/06, Paul Waldo <pwaldo@waldoware.com> wrote:
>> Here is the dmesg output.  No log files are created with the FC5 
>> rescue disk.
>> Thanks!
> I ran into this as well, I believe at this point you want to set:
> 
> md-mod.start_dirty_degraded=1
> 
> as part of your boot options.  Understand you may see some filesystem
> corruption as noted in the documentation.
> 
> See:
> http://www.linux-m32r.org/lxr/http/source/Documentation/md.txt?v=2.6.17#L54
> 
> Regards,
> 
> Dan

Woo Hoo!  I am back in the running!
The md-mod.start_dirty_degraded enabled me to get the array running and 
I can now boot the machine.

Per Neil's comments, I adjusted the partitioning on the new drive 
(/dev/hdd2) to exactly match that of the other partitions in the array. 
  Success!  The array is now rebuilding with the new disk!!

Thanks for everyone's help on this--I'd be dead without it.  In return, 
maybe I can impart a lesson learned.  My big problem was that the new 
replacement disk, even though the same model as the original it was 
replacing, did not have the same geometry as the original.  It was short 
by 2 cylinders, which prevented it from being added to the array.  Next 
time I create an array of "identical" disks, I am going to keep a few 
cylinders on each one unused for just this type of problem.

Again, thanks for all the help!

Paul
