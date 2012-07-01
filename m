From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Resync Every Sunday
Date: Sun, 01 Jul 2012 16:24:09 -0500
Message-ID: <4FF0BFF9.4020207@nuclearwinter.com>
References: <4FF0328B.5080103@abpni.co.uk> <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us> <4FF0B6B2.1080808@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF0B6B2.1080808@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: Keith Keller <kkeller@wombat.san-francisco.ca.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There was a fedora bug in the raid-check script would only queue an
array for check if the array_state was 'clean'. Unfortunately, when the
array is busy performing normal I/O its array_state is 'active'. So, any
arrays which were servicing I/O at the time raid-check was run would not
be checked.

It is quite possible that your CentOS version does not include the fix.

https://bugzilla.redhat.com/show_bug.cgi?id=679843

If it's fixed you should see something like:

# Only perform the checks on idle, healthy arrays, but delay
# actually writing the check field until the next loop so we
# don't switch currently idle arrays to active, which happens
# when two or more arrays are on the same physical disk
array_state=`cat /sys/block/$dev/md/array_state`
if [ "$array_state" != "clean" -a "$array_state" != "active" ]; then
    continue
fi

The fix, iirc, was simply the inclusion of '-a "$array_state" !=
"active"' in the 'if' statement above.

--Larkin


On 7/1/2012 3:44 PM, Jonathan Tripathy wrote:
>
> On 01/07/2012 21:41, Keith Keller wrote:
>> On 2012-07-01, Jonathan Tripathy<jonnyt@abpni.co.uk>  wrote:
>>> What's going on? Am I missing something here? Is data on the arrays at
>>> risk? We're using CentOS 5 with mdadm v2.6.9. Kernel version is
>>> 2.6.18-274.18.1.el5
>> As you are running CentOS, check /etc/sysconfig/raid-check.  Someone may
>> have configured certain arrays not to be checked.
>>
> There is nothing in that file that suggests that some arrays should be
> skipped.
>
> ENABLED=yes
> CHECK=check
> # To check devs /dev/md0 and /dev/md3, use "md0 md3"
> CHECK_DEVS=""
> REPAIR_DEVS=""
> SKIP_DEVS=""
>
> Thanks
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


