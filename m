From: "Thomas C. Bishop" <bishop@latech.edu>
Subject: Re: raid5 messed up
Date: Thu, 7 Sep 2017 08:33:29 -0500
Message-ID: <6e5083a4-609b-daba-3326-0dbd9dda6c34@email.latech.edu>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
 <d08b6aaf-208e-f4bf-7d19-139103eb14cd@turmel.org>
 <42b3f75a-d93d-f20d-579b-901a305fb508@email.latech.edu>
 <59B09036.1040600@youngman.org.uk>
Reply-To: bishop@latech.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59B09036.1040600@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, bishop@latech.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I see what you mean... seems it would be simple enough to find this 
spec. but not clear if supported or not.
Seagate claims this is a "best fit applications" drive for High-Capacity 
RAID storage but never lists ERC as feature.
http://www.seagate.com/files/www-content/partners/my%20spp%20dashboard/learn/en-us/docs/storage-solutions-guide-jul-2013-ssg1351-13-1307us.pdf
pg 30 of the brochure.

  elsewhere@seagate I read ERC is a subset of the smart control commands 
which are supported on this drive so one _might_ think it's supported.

FYI: smartctl --xall  doesn't provide an answer either.
closest it comes is
SMART support is:     Available - device has SMART capability.

Tom

On 09/06/2017 07:17 PM, Wols Lists wrote:
> On 07/09/17 00:47, Thomas C. Bishop wrote:
>> === START OF INFORMATION SECTION ===
>> Vendor:               SEAGATE
>> Product:              ST4000NM0023
> Can't see any mention of ERC in the smart output, but a web search tells
> me this is a Constellation, which I believe does support ERC?
>
> Cheers,
> Wol

-- 
     ***********************************
          Thomas C. Bishop
Hazel Stewart Garner Associate Professor
         Chemistry & Physics
          Tel: 318-257-5209
          Fax: 318-257-3823
         www.latech.edu/~bishop
     ***********************************

