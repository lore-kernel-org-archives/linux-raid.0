From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid6 array ,  part id 'fd' not assembling at boot .
Date: Sun, 18 Mar 2007 20:33:22 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703182011080.24036@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0703161838110.11877@filesrv1.baby-dragons.com>
 <17915.32343.270875.583164@notabene.brown> <45FC3158.3020104@tmr.com>
 <17917.45509.654906.432675@notabene.brown> <45FDC355.5000106@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45FDC355.5000106@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil & Bill ,

On Sun, 18 Mar 2007, Bill Davidsen wrote:
> Neil Brown wrote:
>> On Saturday March 17, davidsen@tmr.com wrote:
>>> Neil Brown wrote:
>>>> In-kernel auto-assembly using partition type 0xFD only works for
>>>> metadata=0.90.  This is deliberate.
>>>> 
>>>> Don't use 0xFD partitions.  Use mdadm to assemble your array, either
>>>> via an initrd or (if it don't hold the root filesystem) via an init.d
>>>> script.
>>>> 
>>> Could you clarify why someone thought it was a good idea to make it 
>>> complex for users to move to current versions of the superblock? Having 
>>> worked with users for way too many years, expecting end users to diddle 
>>> init scripts without shooting themselves in the foot is optimism not 
>>> justified by past results. At least past results as observed by me ;-)
>>> 
>> 
>> That's a loaded question isn't it?  Of course no-one thought it was a
>> good idea to make life complex for anyone.
>> 
> Note smiley!
>> However I do not want to perpetuate a past design mistake of
>> auto-assembling raid array based solely on partition type, and didn't
>> want to burden version-1 superblocks with the information required to
>> support that.  So I didn't. 
> Having something as critical as booting the system depend on an init script 
> of any description just seems inherently less reliably than having the kernel 
> do the job. Scripts depend on an interpreter, the interpreter depends on the 
> library, and while failure is rare, it's not unheard of. So I respectfully 
> disagree on assembly in the kernel being a design mistake, but /boot is not a 
> problem with a 0.90 superblock, so it's not holding anything back.

 	I agree with you Bill ,  Partially .
 	But much less agree with Neil on this subject .
 	Neil suggests that the kernel is the wrong place to assemble arrays .
 	Neil ,  Is that a correct staement ?  But you did stipulate that by
 	saying 'By partition type' in a previous email .

 	Bill suggests that shell scripts of any type 'can' fail .

 	Why can't we have assembling of arrays by UUID IN Kernel ?

 	The UUID's could be placed in the boot command line ,  Yes I know it's
 	a limited resource ,  But a viable resource still .
 	Or even some sort of Signature .  Well that's a uuid in its way .
 	Some sort of signature ,  small enought to be put on the boot command
 	line or where the Kernel can read it . or EVEN in the Kernal .

More below ,  for my reasoning of the above .

>> But neither am I forcing anyone to use version-1 metadata.  Most of
>> the new functionality I have made available in v-1 metadata has also
>> been added to v-0.90 metadata (not quite all, but there are very few
>> needs that would drive someone to use v-1).
>> 
> With superblocks as with real estate, location is important. My prime reason 
> for preferring 1.1 metadata (and I wish there was a painless way to update 
> old arrays).
>> If someone is keen to use the newest features, then I am happy with
>> that, and am happy to provide support and advice.  In doing so I learn
>> about ways that mdadm can be improved to make life easier.  But if you
>> want to use the newest features, you need to understand all the
>> implications there-of.
>> 
>> As a contrast, Debian does force (or strongly encourages) people to use
>> version-1 metadata by putting "CREATE metadata=1" in
>> /etc/mdadm/mdadm.conf.
>> But then Debian also provides all the infrastructure for building an
>> initrd that assembles md arrays for you quite smoothly.   So they
>> provide a complete package that just works (most of the time).
>> 
>> I primarily provide functionality.  It needs to work for everyone:
>> those with legacy configurations that I would not recommend using on
>> new systems, and those who build new systems with different
>> requirements.  I have to provide a variety of options. It is up to the
>> system integrator to choose which bits of functionality to use.
>> 
>> I would be good to create a document discussing the various issues and
>> setting out the preferred config approach for new systems, and I have
>> considered doing this, but unfortunately it hasn't happened yet.
>> 
>> It would suggest:
>>  - If root/swap are on an md device, use an initrd to assemble those
>>     (swap needed for resume-from-hibernate)
>>  - Set homehost in mdadm.conf and use "mdadm -As" to auto-assemble
>>    everything that is meant to be assembled on this host.
>>  - Assemble all arrays as partitionable.
>>  - Use version-1.1 metadata (superblocks at the start cause less
>>    confusion I think)
>>  - run 'repair' every month and don't worry about the mismatch_cnt.
>> 
>> That's all I can think of at the moment.
>> 
> I'm not sure I see the advantage of partitionable arrays for most things, and 
> since it's likely that 90+% of users will do what their distribution install 
> does for them, this sounds like a "best practices" document. Any plans to 
> make 'repair' on RAID levels 5,6,10 check to attempt to identify the bad 
> chunk before rewriting? I hope you vote on RAID-1 with >2 copies, and rewrite 
> the odd man out.

 	What I don't see is the reasoning behind the use of initrd .  It's a
 	kernel ran to put the dev tree in order ,  start up devices ,... Just to
 	start the kernel again ?
 	In otherwords I beleive that initrd's are essentially pointless .  But
 	that's just my opinion .
 		Twyl ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
