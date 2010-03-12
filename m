From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: possible bus loading problem during resync
Date: Fri, 12 Mar 2010 11:43:07 +0000
Message-ID: <73e903671003120343m26999ddle5e01286eebbc93f@mail.gmail.com>
References: <4B95EB5E.5090702@vorgon.com> <73e903671003090230y135d104cte15e07604b85b8aa@mail.gmail.com>
	<4B962A41.50207@shiftmail.org> <871vfrcsk1.fsf@frosties.localdomain>
	<4B9A1ED0.7060902@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9A1ED0.7060902@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 12, 2010 at 11:00 AM, Asdo <asdo@shiftmail.org> wrote:
>
>>> If that is true, how does that happen, the driver is hung? But anyway,
>>> how can such things happen when there is more than one CPU-core?
>>>
>>
>> A drive produces an error, the whole controler hangs and resets all
>> ports, all drives have to finish being reset before any IO can continue.
>> Hapens easily enough.
>>
>
> Ok but this is a multi-core CPU and he said Putty and WinSCP were hung.
> Ok for WinSCP... but Putty?
>
> Timothy is Putty hung on array check even on NCQ disabled?
>
> What is the resync speed? If it is very high it could be a CPU starvation
> but it's strange with only 2 drives. If it is very low I am not sure.
> Are disks write caches enabled?
>
> I am not able to spot any problem from your iostat or dmesg.
> Note: yes the iostat -x 1 was supposed to be captured during resync.
> Trigger a resync manually for the test. You can start it with echo check and
> stop it with echo idle > /sys/block/mdX/md/sync_action
>

I find "gnome-disk-utility" A.K.A. "palimpsest" to be a very good
heuristic to tell whether any drives are giving me physical trouble.
If there is a high remapped-sector-count or if Palimpsest otherwise
thinks a drive is suspect, there is a good chance that any unexplained
slowdowns in the machine are due to that drive.

If nothing more, it's a cheap way to get more information.

(My way of getting Palimpsest to check out drives in a machine that
doesn't have the program available in its installed distro
repositories is to run Ubuntu 9.10 from an USB stick. Boot, and up
comes Palimpsest.)

Hope this helps. Best of luck.

-- Kristleifur
