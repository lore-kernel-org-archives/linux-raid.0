From: Kai Stian Olstad <raid+list@olstad.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 17:19:22 +0200
Message-ID: <07bc0599-df85-17c1-2cec-068bc5b2caec@olstad.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12. okt. 2017 11:50, Alexander Shenkin wrote:
> On 10/11/2017 6:10 PM, Phil Turmel wrote:
>> You'll need to set your hangcheck timer to 180 seconds, too.  I'm not
>> sure how to do that.  (I've never seen this particular combination, but
>> it would be another black mark on desktop drives in raid arrays.)
> 
> Thanks Phil... Googling around, I haven't found a way to change it 
> either, but then again, I'm not really sure what to search for.

Your dmesg did say
[4038193.380526] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.

I guess 0 disables this feature or you could just use "echo 180" or 
"sysctl kernel.hung_task_timeout_secs = 180".

--
Kai Stian Olstad
