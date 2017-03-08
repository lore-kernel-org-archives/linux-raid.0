From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: RAID Recovery
Date: Thu, 9 Mar 2017 02:25:53 +1100
Message-ID: <7f4f3418-8e31-fa83-e161-895e779568ff@websitemanagers.com.au>
References: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
 <e4d9724d-ab52-aa79-c600-7b287c16a182@turmel.org>
 <7cefe670-dcea-6e04-b090-b215a6a218c9@websitemanagers.com.au>
 <94b4591a-bda1-529b-3af1-c451b657082f@websitemanagers.com.au>
 <1066d485-ebea-d0d2-a198-33b560de99fc@turmel.org>
 <c9a70435-56a5-9295-2582-7b71a71619eb@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c9a70435-56a5-9295-2582-7b71a71619eb@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 8/3/17 20:08, Adam Goryachev wrote:
>
>
> On 8/3/17 02:00, Phil Turmel wrote:
>> Hi Adam,
>>
>> Search the devices for ext2/3/4 superblocks, like so:
>>
>> dd if=/dev/sdX bs=1M 2>/dev/null |hexdump -C |grep '30  .\+ 53 ef 0'
> What is the chance it is a ext2/3/4 based FS? I suppose most NAS would 
> use these filesystems... I guess I'll find out soon enough.
>
>> This will take a very long time, and will generate false positives.
> Can you advise what to do to "verify" these and work out which ones 
> are false positives?
>> You probably would want to use screen or tmux to run these in
>> parallel in separate processes.
> I'm not sure there is much of a point, since they are mostly 
> duplicates of each other. I'm running it on sdd now, and copying sda 
> and sdc to a spare drive. I may re-run the command on sdc (and skip 
> the first 490GB...) if nothing useful is found on sdd.
>> But superblock locations will give you hints as to the rest of data,
>> and make it possible to create partitions that will let you copy
>> stuff off into a new array.
>>
>

OK, so the first disk has completed and found 85 matches, I don't think 
there is any point in posting the raw output, but can you advise what I 
should do with it? Here is the first few matches:
082f6c30  3a 5d f7 a2 d0 52 ab ba  53 ef 0d 6d 51 d0 2a 76 
|:]...R..S..mQ.*v|
21146d30  cf 17 bf 15 bf 9e e2 67  53 ef 05 15 a7 89 ae 38 
|.......gS......8|
217e2730  73 0f 3c 00 99 68 a4 ed  53 ef 0f b4 ed 8d a6 7b 
|s.<..h..S......{|
4c64f430  a4 48 02 00 00 00 86 00  53 ef 00 00 03 7a 1f 09 
|.H......S....z..|
4c688430  a4 48 02 00 00 00 86 00  53 ef 00 00 03 7a 1f 09 
|.H......S....z..|
e8724430  00 2b 02 17 71 e3 27 3b  53 ef 0c f3 90 3b 0c 0e 
|.+..q.';S....;..|
f1fd0d30  53 ef 04 cd 4d ef 04 cd  53 ef 04 cd 4d ef 04 cd 
|S...M...S...M...|
fb9a2930  ce f0 97 69 a0 f2 1b 07  53 ef 0b 95 74 ff 98 c9 
|...i....S...t...|
10a0c9d30  41 2c 9b 24 7f bf ec 76  53 ef 0f 07 3e 0a 3d 15 
|A,.$...vS...>.=.|
15bd95430  e1 72 92 fb 73 64 a4 1a  53 ef 0b 6a 66 e1 ef ae 
|.r..sd..S..jf...|


Regards,
Adam

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au

