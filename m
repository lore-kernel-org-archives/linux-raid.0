From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: mdassemble will disappear - last chance to stop it!
Date: Tue, 11 Apr 2017 10:48:27 -0400
Message-ID: <7660b823-cbf9-99af-78e1-88d6c59695ec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

 From conversation in other another thread, it seems obvious that 
mdassemble is a thing of the past that nobody really seems to care about.

To get rid of the cruft and having to maintain code that has little 
chance of working with modern kernels, I am going to start removing all 
trace of it from the mdadm codebase.

If you have any compelling reason for wanting to keep mdassemble around, 
now would be a good time to state it.

Thanks,
Jes
