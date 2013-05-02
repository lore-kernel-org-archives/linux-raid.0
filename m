From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Anything left to try?
Date: Thu, 2 May 2013 11:31:05 -0500
Message-ID: <CAPSPcXgQ3zKx=hy344XOqKn=1_x+T=VstXTNJwjC+ZAEwmN4zQ@mail.gmail.com>
References: <CAPSPcXjFQ9zDP9ZK8X3uZXHNKot5hS=0iwj04E_FrNa2Z8n++A@mail.gmail.com>
	<C480F6221151144EA453A5C89300815601403A74@MBOX1.ds.sbdhi.com>
	<CAPSPcXhS2O8ASH8Gsz8KE=oJp6y1K6VTi7Jf-=39uzNzG3SnJQ@mail.gmail.com>
	<20130502145829.GB18405@cthulhu.home.robinhill.me.uk>
	<20130502150932.GA13438@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130502150932.GA13438@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin@robinhill.me.uk
List-Id: linux-raid.ids

Just an --assemble --force eh?  Thanks, I will try it soon and report!

On Thu, May 2, 2013 at 10:09 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Thu May 02, 2013 at 03:58:29PM +0100, Robin Hill wrote:
>
>> On Thu May 02, 2013 at 09:26:55AM -0500, Barrett Lewis wrote:
>>
>> > That is a really good idea.  At minimum I will ddrescue the failed drives.
>> > But even if I do that, is there a way to reassemble the array (even with
>> > new drives) now that those components are marked failed?
>> >
>> Yes, "mdadm -Af /dev/mdX" should reassemble the array, making use of the
>> best set of drives available to get the array running - i.e. all the
>> working drives plus the most-recently failed drive(s). It'll still be in
>> a degraded state, but hopefully you can then get the other disk added
>> (though you'll still have to keep your fingers crossed that there's no
>> read error of any kind during the several days required to rebuild a 4T
>> drive).
>>
> Sorry, got you mixed up with someone else there. Anyway, the command
> should reassemble the array and allow you to get the rest of the data
> off. You might want/need to also specify the disks/partitions it should
> be using for the assembly.
>
> Cheers,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
