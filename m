From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: question about bitmaps and dirty percentile
Date: Mon, 03 Aug 2009 16:30:14 -0400
Message-ID: <4A7748D6.7060307@steeleye.com>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>	<cccedfc60907301216h769eadd7oc575dd3ae04f64bb@mail.gmail.com>	<4A733551.5010408@steeleye.com>	<cccedfc60907311209o2637c2f2vcda619763f79037a@mail.gmail.com> <h57469$u6a$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h57469$u6a$2@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs wrote:
> On Fri, 31 Jul 2009 14:09:06 -0500, Jon Nelson wrote:
> 
>>> The bitmap never gets cleared unless all disks in the array are in
>>> sync.
>> Well, that sucks. What is the reasoning behind that?
> 
> There's only one bitmap per device. If the bits get cleaned writing to 
> disk #2, then the system would forget that they still need to be written 
> to disk #3.

Right, and that decision was made for efficiency and simplicity of 
design. Having a bitmap per pair of component disks would be inefficient 
and very complicated. You could stack raid1's if you absolutely had to 
have that type of functionality.

--
Paul


