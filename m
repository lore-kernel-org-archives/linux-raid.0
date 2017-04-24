From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 18:00:12 +0200
Message-ID: <834b92f2-8e79-32de-4aab-09dbe553b017@powerlamerz.org>
References: <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <CAHKno4BwvVTtwqrHjTF8seSgR-QArmvATwuNy_21ctUPdh0biA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHKno4BwvVTtwqrHjTF8seSgR-QArmvATwuNy_21ctUPdh0biA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/24/2017 04:05 PM, Patrik Dahlström wrote:
> 2017-04-24 15:39 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
>> On Mon, Apr 24, 2017 at 02:54:50PM +0200, Patrik Dahlström wrote:
>>> What offset are you referring to here? The --data-offset to the mdadm
>>> --create command?
>>
>> Yes, data offset...
> It all makes sense to me now! I believe I was still in sort of a
> panicked mode yesterday. The pieces are starting to make more sense
> today.
Picking the offset I found out yesterday, I did indeed get a ext4 file
system on the 6 disk raid. I could even mount it at one point. Strangely
enough, I also got a file system  on the 5 disk raid. Running a quick
test showed that offset 0.5 MB to 1.5 MB (3 chunks) had identical data,
and also one chunk at 32 GB. I'm gonna leave the program running for a
while now and see what I can figure out. The first chunk is most
probably identical too, but my program ignores chunks that are all zeros.
> 
>> Another thing you can check is, pick an arbitrary offset that does not
>> have zeroes on the disks, and see if the XOR matches for 5, or 6 disks.
> I will try that when I get home.
Still haven't tried this. I have some life stuff to do as well.

Best regards
// Patrik
