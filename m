From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Use more secure HTTPS URLs
Date: Thu, 14 May 2020 17:42:09 -0400
Message-ID: <e83921a0-fed5-be7f-e5ff-5a3f37cb53ec@gmail.com>
References: <20200513132707.16744-1-pmenzel@molgen.mpg.de>
 <f2d4fa4e-697f-033a-1144-d4ff30e48ec3@gmail.com>
 <844fa4e8-fe19-ad46-55e3-1357518f1366@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <844fa4e8-fe19-ad46-55e3-1357518f1366@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/14/20 4:39 PM, Paul Menzel wrote:
> Dear Jes,
> 
> 
> Am 13.05.20 um 15:44 schrieb Jes Sorensen:
>> On 5/13/20 9:27 AM, Paul Menzel wrote:
>>> All URLs in the source are available over HTTPS, so convert all URLs to
>>> HTTPS with the command below.
>>>
>>>      git grep -l 'http://' | xargs sed -i 's,http://,https://,g'
>>>
>>> Cc: linux-raid@vger.kernel.org
>>> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
>>
>> Some of this looks valid, but we're not going back to update existing
>> ANNOUNCE files.
> 
> May I ask why? It’s all logged in the VCS history, and the two URLs are
> always the same.

Because those are release files and that's to edit history.

Jes
