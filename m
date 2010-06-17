From: Adrian Sandor <aditsu@yahoo.com>
Subject: RAID10 n1 layout?
Date: Thu, 17 Jun 2010 03:02:09 -0700 (PDT)
Message-ID: <268626.87856.qm@web32401.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I've just created a RAID10 with mdadm using default options, and with -v it said:
    mdadm: layout defaults to n1
According to the docs, the default should be n2, and n1 would mean no redundancy (like RAID0)
Furthermore, after creating the array, I checked it with -D and it said:
    Layout : near=2
Is this a bug?
I'm using mdadm 3.0

Thanks
Adrian


      
