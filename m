From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Resync Every Sunday
Date: Mon, 02 Jul 2012 12:06:26 -0500
Message-ID: <4FF1D512.8030406@nuclearwinter.com>
References: <4FF0328B.5080103@abpni.co.uk> <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us> <4FF0B6B2.1080808@abpni.co.uk> <4FF0BFF9.4020207@nuclearwinter.com> <4FF0C7C0.7020706@abpni.co.uk> <4FF0C8AF.9020703@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF0C8AF.9020703@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 7/1/2012 5:01 PM, Jonathan Tripathy wrote:
>
> On 01/07/2012 22:57, Jonathan Tripathy wrote:
>>
>> On 01/07/2012 22:24, Larkin Lowrey wrote:
>>> There was a fedora bug in the raid-check script would only queue an
>>> array for check if the array_state was 'clean'. Unfortunately, when the
>>> array is busy performing normal I/O its array_state is 'active'. So,
>>> any
>>> arrays which were servicing I/O at the time raid-check was run would
>>> not
>>> be checked.
>>>
>>> It is quite possible that your CentOS version does not include the fix.
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=679843
>>>
>>> If it's fixed you should see something like:
>>>
>>> # Only perform the checks on idle, healthy arrays, but delay
>>> # actually writing the check field until the next loop so we
>>> # don't switch currently idle arrays to active, which happens
>>> # when two or more arrays are on the same physical disk
>>> array_state=`cat /sys/block/$dev/md/array_state`
>>> if [ "$array_state" != "clean" -a "$array_state" != "active" ]; then
>>>      continue
>>> fi
>>>
>>> The fix, iirc, was simply the inclusion of '-a "$array_state" !=
>>> "active"' in the 'if' statement above.
>>>
>>> --Larkin
>> Hi Larkin,
>>
>> This sounds like exactly what I'm experiencing.
>>
>> Is this 'if' statement supposed to be in the raid-check script? I
>> don't have any if statement in my raid-check script
>>
>> Thanks
>>
> Here is a small part of my 99-raid-check script:
>
> for dev in $active_list; do
>     echo $SKIP_DEVS | grep -w $dev >/dev/null 2>&1 && continue
>     if [ -f /sys/block/$dev/md/sync_action ]; then
>         # Only perform the checks on idle, healthy arrays, but delay
>         # actually writing the check field until the next loop so we
>         # don't switch currently idle arrays to active, which happens
>         # when two or more arrays are on the same physical disk
>         array_state=`cat /sys/block/$dev/md/array_state`
>         sync_action=`cat /sys/block/$dev/md/sync_action`
>         if [ "$array_state" = clean -a "$sync_action" = idle ]; then
>             ck=""
>             echo $REPAIR_DEVS | grep -w $dev >/dev/null 2>&1 &&
> ck="repair"
>             echo $CHECK_DEVS | grep -w $dev >/dev/null 2>&1 && ck="check"
>             [ -z "$ck" ] && ck=$CHECK
>             dev_list="$dev_list $dev"
>             check[$devnum]=$ck
>             let devnum++
>             [ "$ck" = "check" ] && check_list="$check_list $dev"
>         fi
>     fi
> done
>
> So the bug hasn't been fixed in my version then?
>
> Thanks
That is not the correct logic so your script is out of date. I would
recommend updating your mdadm package via yum. My CentOS 6.2 install has
the correct logic in /usr/sbin/raid-check, which is the new location for
the script. The RPM I have installed is mdadm-3.2.2-9.el6.x86_64.

--Larkin
