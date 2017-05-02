From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: mdadm/mdmon Name vs argv[0]
Date: Tue, 2 May 2017 10:19:08 -0400
Message-ID: <a61470a2-2c3b-3f4a-5712-dfb87f3acad8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: pawel.baldysiak@intel.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Pawel,

In the below commit you changed the handling of how mdadm/mdmon handles 
printing the name of the running process.

However, if people for some reason decided to change the names of 
mdadm/mdmon this would no longer be correct.

Do you remember if there is any reason why you didn't use argv[0] for this?

commit d56dd607ba433d9334f0fb4114fe081742ae4361
Author: Pawel Baldysiak <pawel.baldysiak@intel.com>
Date:   Wed Feb 11 22:25:03 2015 +0100

     Change way of printing name of a process

Cheers,
Jes
