From: David Brown <david.brown@hesbynett.no>
Subject: Re: Growing layered raids
Date: Tue, 12 Apr 2011 22:47:39 +0200
Message-ID: <io2dpb$r2n$1@dough.gmane.org>
References: <invsor$qrt$1@dough.gmane.org> <20110412082719.17fa4ffb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412082719.17fa4ffb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/04/11 00:27, NeilBrown wrote:
> On Mon, 11 Apr 2011 23:44:58 +0200 David Brown<david.brown@hesbynett.no>
> wrote:
>
>> Am I right in thinking that you cannot grow the size of a raid array
>> that is build on top of other arrays?
>
> Not - in general it should work just the same as building out of any other
> device.
>
>>
>> I am doing some experiments at the moment with small loopback devices
>> mapped to files on a tmpfs file system - the idea being I can play
>> around with my fake "disks" without any risk, and with resync times
>> faster than I can type.
>
> Very sensible!
>
>
>>
>> My setup is like this (in case anyone wants to try it) :
>>
>> mount -t tmpfs tmpfs /root/loops
>> dd if=/dev/zero of=/root/loops/loop1 bs=1M count=128
>> dd if=/dev/zero of=/root/loops/loop2 bs=1M count=128
>> dd if=/dev/zero of=/root/loops/loop3 bs=1M count=128
>> dd if=/dev/zero of=/root/loops/loop4 bs=1M count=160
>> dd if=/dev/zero of=/root/loops/loop5 bs=1M count=160
>> dd if=/dev/zero of=/root/loops/loop6 bs=1M count=160
>>
>> losetup /dev/loop1 /root/loops/loop1
>> ...
>> losetup /dev/loop6 /root/loops/loop6
>>
>> This gives me 6 "disks" - 3 x 128 MB disks, and 3 x 160 MB disks.
>>
>> Make some single-disk "mirrors":
>>
>> mdadm --create /dev/md/mdpair1 --level=1 --force -n 1 /dev/loop1
>> mdadm --create /dev/md/mdpair2 --level=1 --force -n 1 /dev/loop2
>> mdadm --create /dev/md/mdpair3 --level=1 --force -n 1 /dev/loop3
>>
>>
>> Make a raid5 with no redundancy, so it's easy to see if something goes
>> horribly wrong:
>>
>> mdadm --create /dev/md/mdr --level=5 -n 4 /dev/md/mdpair1
>> /dev/md/mdpair2 /dev/md/mdpair3 missing
>>
>>
>> Make and mount a file system, and put some data on it - so we can check
>> the data is still there.
>>
>> mkfs.ext4 /dev/md/mdr
>> mkdir m
>> mount /dev/md/mdr m
>> cp -r /usr/share m
>>
>>
>> At this stage, I've got a degraded raid5 with about 384MB space, in use
>> as a mounted file system.
>>
>>
>> Now I want to swap out each of my 128 MB "disks" with 160 MB "disks".  I
>> want to do that without reducing the redundancy of the main raid (in the
>> real world, it would be raid 6 - not a degraded raid 5), and by using
>> mirror copies to minimise the strain on the other disks.
>>
>> Add a new disk as a "hot spare" to a pair:
>>
>> mdadm --add /dev/md/mdpair1 /dev/loop4
>>
>> Change it to being a 2-drive mirror
>>
>> mdadm --grow /dev/md/mdpair1 -n 2
>>
>> Wait for the sync to complete...
>>
>> Remove the small disk and change it back to a 1-drive mirror
>>
>> mdadm --fail /dev/md/mdpair1 /dev/loop1
>> mdadm --remove /dev/md/mdpair1 /dev/loop1
>> mdadm --grow /dev/md/mdpair1 -n 1 --force
>>
>> Now I can grow the one-disk mirror to use the whole new disk:
>>
>> mdadm --grow /dev/md/mdpair1 --size=max
>>
>>
>> Repeat the procedure for the other two mdpair components.
>>
>> My raid5 array is build on top of these three raid1 mirrors, which have
>> now all increased from 128 MB to 160 MB (confirmed by mdadm --detail and
>> blockdev --report).
>>
>> But when I try to grow the raid 5 array, nothing happens:
>>
>> mdadm --grow /dev/md/mdr --size=max
>>
>> I am still getting a "component size" of 128 MB.
>
> You need to tell md2 that each of it's components has grown.
> If the RAID5 has metadata at the end of the device (0.90 or 1.0), then
> this array is quite unsafe.  If you stop and restart mdadm will not be able
> to find the metadata - it is in the middle of the device somewhere.
> If the metadata is at the start then you are safer, but the metadata still
> thinks it knows the size of each device.
>
> If the metadata is at the start, you can stop the array and assemble it again
> with
>      --update=devicesize
>
> then the --grow --size=max will work.
>
> If the metadata is at the end of the device, then as soon as the device
> becomes bigger, you really should
>     echo 0>  /sys/block/mdXX/md/dev-mdYY/size
> where XX is the raid5 and YY is the raid1 that you have grown.
> That tells md to re-assess the size of the device and write new metadata.
> It would be good if the kernel did this automatically but it cannot yet.
>
> You can also do this with metadata at the start of the device.
>
> Once you have told md that the size of each device has changed, then you can
> ask it to grow the array to match this new size.
>
> The next release of mdadm should do this for you.  i.e. when you run
>    --grow --size=max
> it will reset the size of each component first.
>
>

I used:

echo 0 > /sys/block/md124/md/dev-md127/size
echo 0 > /sys/block/md124/md/dev-md126/size
echo 0 > /sys/block/md124/md/dev-md125/size

(My /dev/md/mdr is md124, and my /dev/md/mdpair1 .. 3 are md127 .. 125. 
  The /sys/block/ interface only seems to use the numerical names, not 
the symbolic ones I had used.)

Then:

mdadm --grow /dev/md/mdr --size=max
resize2fs /dev/md/mdr

And my file system was grown - safely and smoothly, with everything 
online the whole time.  No need to stop and re-start any arrays.

One might say it's a touch unintuitive, using the /sys interface like 
this, but the result is an amazing level of flexibility.  By building my 
main raid on top of 1-disk "mirrors", I could do the replacement and 
resize safely and efficiently without ever reducing the redundancy of 
the raid.  Very nice, and a feature that I think no hardware raid system 
can offer.

I tried to be as complete as possible in the details of my post here, so 
that other people can copy the loopback setup if they want do do their 
own testing.

I have a new server on it's way, so I'll soon be able to try this out 
for real.

Thank you for your help, and of course for the software.

mvh.,

David



