From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: [Fwd: Re: Missing superblock on one of the raid devices on raid
 0 with 1.2 metadata]
Date: Fri, 15 Mar 2013 16:57:14 +0000
Message-ID: <514352EA.8090607@mpstor.com>
References: <1363335578.29317.0.camel@hanna64.taxback.ess.ie> <1363335845.18187.10.camel@gandalf.taxback.ess.ie> <51434C5B.9080007@mpstor.com> <514351E2.5030408@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <514351E2.5030408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Ivan Yordanov <iyordanov@taxback.com>, Nikolay Kichukov <nkichukov@taxback.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/03/13 16:52, Phil Turmel wrote:
> Hi Ivan,
>
> On 03/15/2013 12:29 PM, Benjamin ESTRABAUD wrote:
>
> [trim /]
>
>> The fact that you have the position of all the other drives from the
>> array is good. Now we want the last drive's superblock to be written.
>> Since we know the position of all the drives, and assuming you know the
>> *exact* arguments passed to mdadm when you first created your raid0
>> (correct metadata version, chunk size, etc. (most can be found in the
>> existing superblocks), you could call "mdadm --create " with the same
>> version of mdadm and MD used when creating the array initially, the same
>> options and arguments, and *very important* the drives in the same
>> order, which I believe to be: /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>> (according to the info above).
>>
>> This will create a new array, but since you are recreating the same
>> *exact* array, the existing data should be there and available untouched.
> This is all correct, and is the correct next step.
>
>> However, as a word of warning, many things can go wrong this this
>> command: If you were to recreate the array slightly differently and
>> start overwriting your array you would destroy the data on it. The fact
>> that it is a RAID0 is good since creating a new array won't start a
>> resync that could be fatal should you have made a mistake providing the
>> arguments for the recreation. So the above should be generally safe,
>> provided you keep a copy of the information you gave us above and match
>> the "create" arguments perfectly.
> You can check your work by re-issuing the "mdadm -E" commands after
> re-creating the array.  The data offset and chunk size must match the
> originals.
>
> If they do, then you can mount the filesystem.
One thing though: Note that your array will be recreated with a new 
array UUID, creation time, and possibly other attributes (although none 
related to the contents of the RAID, the data), should you rely on the 
RAID UUID for anything in particular. It is highly unlikely but just to 
let you know in case you run into troubles with some applications 
depending on the RAID uuid.
> Phil
>

