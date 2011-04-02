From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: [PATCH] RAID-6 check standalone md device
Date: Sat, 02 Apr 2011 11:33:33 +0100
Message-ID: <4D96FB7D.3060305@tuxes.nl>
References: <20110221204551.GA15675@lazy.lzy> <20110321140244.2314b4b4@notabene.brown> <20110321104007.GA15379@lazy.lzy> <20110321220457.29d52f5c@notabene.brown> <20110321115440.GA15635@lazy.lzy> <20110322095905.737fb1d5@notabene.brown> <20110331185346.GA5210@lazy.lzy> <4D96597C.1020103@tuxes.nl> <20110402071310.GA2640@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110402071310.GA2640@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/02/2011 08:13 AM, Piergiorgio Sartor wrote:
> Hi Bas,
>
> On Sat, Apr 02, 2011 at 12:02:20AM +0100, Bas van Schaik wrote:
>> Dear Piergiorgio,
>>
>> On 03/31/2011 07:53 PM, Piergiorgio Sartor wrote:
>>> please find below the promised patch for the
>>> RAID-6 check, which allows to pass only the
>>> MD device, start and length.
>>> (...)
>> Recently, I repeatedly ran into block mismatches in my 8x2TB RAID-6
>> array (and a corrupted EXT3 filesystem). I've been playing with the idea
>> (as expressed in my posts to the linux-raid list in the last month) to
>> extend the RAID-6 check in order to report more verbose information
>> about a block mismatch, which might help to identify the failing hard drive.
>>
>> Do I understand correctly that your recent patches implement exactly
>> this feature?
> yes, that's the target.
That's great! The code can currently only be found in GIT, right? I'll
try to fetch it from there and compile the user-space binaries. Of
course I'll report any suggestions back to you, including patches if I
feel confident enough...

Thanks,

  Bas
