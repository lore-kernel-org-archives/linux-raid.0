From: Dylan Distasio <interzone@gmail.com>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Sun, 5 Jan 2014 12:06:12 -0500
Message-ID: <CAJrqPH-mOGeupVYJ3tCCOrtx8cnpjoyOP=fW5GZdKqD0HVtyRw@mail.gmail.com>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
 <CAAMCDee00xy+06FnDq15qaXZmvh9TNSQQcfV8qExgu2DvScm2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDee00xy+06FnDq15qaXZmvh9TNSQQcfV8qExgu2DvScm2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the trick.  The issue of complicating things with MD is
what I am concerned about.  I am afraid to boot the PC up with drives
missing (if for example I remove the highpoint controller) because it
may end up assembling an array with drives missing and degrading it
when it didn't need to be.

I'm really wishing I had labeled my drives now, since I don't know
which ones are part of which array physically, and don't want any
arrays to assemble until I do.  I was wondering if booting into a live
CD would be the way to go.  I need some way of checking which drive is
in which array without the risk of any arrays assembling.

On Sun, Jan 5, 2014 at 11:33 AM, Roger Heflin <rogerheflin@gmail.com> wrote:
> The crude but simple way is this:
>
> Get the machine up with all disks that will work.
>
> dd if=/dev/mdX of=/dev/null on each array, noting which disks light
> up, repeat on all arrays, same process can be done with each disk (dd
> if=/dev/sdX of=/dev/null ) to see exactly what disk maps to where.
> This trick is rather nice since it pretty much works with
> everything...even if you have a hw raid controlled and a failed disk,
> that will be the one disk that never lights, so you can find the
> failed on there also, just make sure that when done you have the
> expected number of disks to not light up.
>
> The biggest issue is that if the md's come up missing the 4 drives it
> may complicate things with MD, though at worse that should require
> some usage of the raw mdadm command to force things on after doing
> this.
>
> On Sun, Jan 5, 2014 at 9:04 AM, Dylan Distasio <interzone@gmail.com> wrote:
>> Hi all-
>>
>> I''ve been fortunate enough to not have to email this august group for
>> advice regarding my mdadm arrays in quite awhile, but am looking for
>> some suggestions.
>>
>> I woke up this morning to something beeping in my headless Norco
>> server case at home (never a promising start to the morning).  I was
>> unable to ping the box which increased my dismay.  I proceeded to
>> perform a hard reboot, and still nothing on the ping.  At this point,
>> I plugged a monitor in to see what was happening on reboot.
>>
>> Let me take a moment to provide details of my basic set up.  There are
>> three separate HD controllers being used in this box: the motherboard
>> headers, a supermicro PCI-X card (in a PCI slot), and a Highpoint
>> RocketRaid SAS controller used as JBOD.
>>
>> I have a number of separate mdadm arrays tied to this physical box
>> that have been built over the years including a RAID6 one, a RAID10,
>> and 2 mirrors.
>>
>> Unfortunately, I did not take the time to physically label the drives
>> in the box (there are close to 20) as I built these, and had been
>> meaning to, but life got in the way.  Since I have had no issues with
>> these arrays in a very long time, I don't even remember if I split
>> them across controllers or what.
>>
>> So back to the reboot, I can see the motherboard drives showing up as
>> the POST runs through its paces.  I can then see what appears to be
>> the Supermicro drives showing up, but when the Highpoint controller
>> gets to it own internal boot screen, it hangs at detecting drives, and
>> I am unable to get into the controller card BIOS by hitting ctrl-H
>> (keyboard works though, as I can ctrl-alt-delete, so it is not locking
>> the PC).
>>
>> So at this point, I don't know my point of failure.  I am guessing the
>> Highpoint flaked out though, especially since I now believe that was
>> the component beeping based on the PC restarting ok otherwise.
>>
>> I am looking for advice on minimizing my risk of making things worse
>> as I attempt to identify what drives belong which with array.   The
>> RAID6 is my most immediate concern in getting back up and running.
>>
>> My immediate thought was to disconnect all drives and then reconnect
>> them one by one from a motherboard header, and use:
>>
>> mdadm --examine /dev/sdX1
>>
>> Will that give me enough info to figure out which drive belongs to
>> which array?  Does anyone have any other suggestions?  I am not sure
>> of the current state of ANY of the arrays that were on this box, but I
>> don't want to make things worse by booting this system up with some
>> drives missing because I've unplugged them, and having the a bad
>> situation get worse.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
