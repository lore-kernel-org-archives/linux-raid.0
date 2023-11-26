Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 43304 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Nov 2023 16:23:52 PST
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C6910F
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 16:23:51 -0800 (PST)
Received: from host109-150-116-140.range109-150.btcentralplus.com ([109.150.116.140] helo=[192.168.1.99])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1r7E9E-0000aD-52;
	Sun, 26 Nov 2023 12:22:04 +0000
Message-ID: <d1ab59c2-e172-400d-8d6c-68f4bfce3a65@youngman.org.uk>
Date: Sun, 26 Nov 2023 12:22:03 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMR or SSD disks?
Content-Language: en-GB
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
 Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
 <ZWMf+lg/CgRlxKtb@mail.bitfolk.com>
 <20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
From: Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/11/2023 11:55, Hannes Reinecke wrote:
> On 11/26/23 11:37, Andy Smith wrote:
>> Hello,
>>
>> On Sun, Nov 26, 2023 at 11:18:39AM +0100, Gandalf Corvotempesta wrote:
>>> i'm doing some maintenance replacing some not-yet-failed HDD with WD 
>>> RED SSD.
>>> I've read the warning on the homepage
>>> https://raid.wiki.kernel.org/index.php/Linux_Raid
>>>
>>> Are SSD drives still subject to SMR ? I've thought that it was related
>>> only to magnetic drives not on SSD.
>>
>> SMR is not applicable to flash-based storage. I expect the warning
>> on the wiki was written at a time when the only drives bearing the
>> WD Red brand were HDDs, not any SSDs.

Yes. The WD Red line was always advertised as "optimised for raid" 
(which was debatable, but okay), then they switched it to SMR. So the 
notice was saying "keep away !!!". I think several new SMR Reds failed 
badly when people tried to rebuild their array.
>>
> Correct. Typically SATA SSDs do not expose SMR capabilities; it's all
> hidden by the FTL there.

If you look at what SMR is, it's only relevant to spinning rust. It 
relies on the fact that a read head can be much smaller than a write 
head, so provided you shingle your writes (hence the name), you can 
over-write half the previous track (so saving space) without rendering 
the data unreadable.

The problem is you have to stream your writes, you can't go back, which 
is why these drives - especially the early ones - had a habit of 
stalling for minutes on end, as they shuffled stuff around.
> 
> And the warning really is outdated. What matters is that the HDD needs
> to support TLER (ie scterc capabilities); the brand or series really is 
> immaterial. There are plenty of non-SMR HDDs which do not support it. 
> Sadly it's not well advertised, so you really have to test
> (or invest in the HDD range which is geared up for this kind of usage.)
> 
I'm not sure how true that is now, I've not been keeping up. But about 
that time (2020), most desktop drives - the sort that don't have TLER - 
were transitioning to SMR. Hence the warning following immediately - 
don't use desktop drives! I suspect non-SMR is now a premium feature 
which will usually come with TLER as a matter of course.

As I say, I'm not up-to-date any more. If anybody can give me some 
facts, I'll happily update the site.

Cheers,
Wol
