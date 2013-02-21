From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 14:24:23 -0500
Message-ID: <51267467.9040603@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heis
 l.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51267192.6090205@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 02:12 PM, Stone wrote:

>>> ok. with --chunk=64 i cannot open the luks.
>>> in witch steps (chunk) should i continue?
>> That is a big surprise.  The luks signature should not move with chunk
>> size.  Please use "mdadm -E /dev/sdc1" to recheck your data offset.
>>
>> If that wasn't it, please show the hexdump for the entire luks
>> signature.  I'd like to see its payload offset.
>>
>> Also, if you go back to --chunk=512, open the luks, you could run the
>> following command to find possible superblock locations:
>>
>> hexdump -C /dev/mapper/md2_nas |egrep '^[0-9a-f]+30  .+  53 ef' >sb.lst
>>
>> (May take a long time to read the whole array)
>>
>> Phil
> with --chunk=512 i can open the luks but i cannot found a good superblock.
> yes i can run the hexdump but i think this runs 8 hours or longer.
> start the hexdump?
> can i try more today?

Run the hexdump for half an hour or so.  If it doesn't find some
candidates in that timeframe, it probably won't.

I've never crashed a luks partition like this, so I'm feeling around a
bit.  You should understand that luks normally uses "cipher block
chaining" salted with the sector number.  If you get the blocks out of
order (wrong chunk size or offset or layout), those sectors won't
decrypt correctly.  luksOpen won't detect this.

You may have to try many chunk sizes, verifying the data offset every
time, trying to find the one that will work.

Phil
