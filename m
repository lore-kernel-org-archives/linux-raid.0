From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: question about bitmaps and dirty percentile
Date: Mon, 3 Aug 2009 16:44:57 +0000 (UTC)
Message-ID: <h57469$u6a$2@ger.gmane.org>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
	<cccedfc60907301216h769eadd7oc575dd3ae04f64bb@mail.gmail.com>
	<4A733551.5010408@steeleye.com>
	<cccedfc60907311209o2637c2f2vcda619763f79037a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 31 Jul 2009 14:09:06 -0500, Jon Nelson wrote:

>> The bitmap never gets cleared unless all disks in the array are in
>> sync.
> 
> Well, that sucks. What is the reasoning behind that?

There's only one bitmap per device. If the bits get cleaned writing to 
disk #2, then the system would forget that they still need to be written 
to disk #3.

-- 
Matthias Urlichs

