From: Maarten <maarten@ultratux.net>
Subject: Re: 3-disk fail on raid-6, examining my options...
Date: Tue, 18 Jul 2017 23:29:48 +0200
Message-ID: <f7afb0d1-579d-9647-6055-99093b74cc3a@ultratux.net>
References: <07b77b80-4bee-3820-6a0d-3323ef06a3f3@ultratux.net>
 <596E6D72.8050108@youngman.org.uk> <20170718202550.GA2533@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170718202550.GA2533@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/18/2017 10:25 PM, Wakko Warner wrote:
> Wols Lists wrote:
>> On 18/07/17 18:20, Maarten wrote:
>>> Now from what I've gathered over the years and from earlier incidents, I
>>> have now 1 (one) chance left to rescue data off this array; by hopefully
>>> cloning the bad 3rd-failed drive with the aid of dd_rescue and
>>> re-assembling --force the fully-degraded array. (Only IF that drive is
>>> still responsive and can be cloned)
>>
>> If it clones successfully, great. If it clones, but with badblocks, I
>> keep on asking - is there any way we can work together to turn
>> dd-rescue's log into a utility that will flag failed blocks as "unreadable"?
> 
> I wrote a shell script that will output a device mapper table to do this. 
> It will do either zero or error targets for failed blocks.  It's not
> automatic and does require a block device (loop for files).  I've used this
> several times at work and works for me.
> 
> I'm not sure if this is what you're talking about or not, but if you want
> the script, I'll post it.

For me, I don't think it will make much difference. On top of the array
there are a number of LVM volumes. Of most of them I have full and
current backups. Some of it is [now] free space. There are two volumes
that hold data that is both important to me and not backed up recently
enough.

Those two volumes together take up about 33%-40% of the total size. So
the chances of bad sectors affecting these are also (somewhat) smaller.
And the data will still be valuable to me, even when it has some silent
corruption.

No, my main question that I seek a definitive answer to is whether the
two drives that failed earlier hold anything of worth, or that any
salvaging data using them is out of the question.

In the mean time, I occupy my time with copying the data I wanted to
copy onto the array to a remote system, and to make sure all my backups
and copies that were not redundant get proper redundancy. I will not
'touch' the machine with the broken array until all that is sorted (it
has an other raid-6 array, which is healthy... for now at least).

I hope the 3rd failed drive won't deteriorate during that time, but
under the circumstances, I'm going to take that risk nonetheless.

regards,
Maarten
