From: "=?GB2312?B?yubQxw==?=" <xshu2006@gmail.com>
Subject: Re: raid5 grow problem
Date: Thu, 17 Aug 2006 17:23:10 +0800
Message-ID: <7de068fd0608170223g2009962chc222233c70ee9317@mail.gmail.com>
References: <7de068fd0608161815yc34ec6bl886fa637691ee5f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7de068fd0608161815yc34ec6bl886fa637691ee5f8@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dear sir:
          i try to make a reshape command with mdadm (version
2.5.2).in linux shell ,i make
$:mdadm -G /dev/md5 /dev/sdd2
/dev/md5 is a raid5 device with 4 disks,/dev/sdd2 is a partition
it give the prompt :mdadm :can only add devices to linear arrays,but i
have read the resourse code of mdadm(V2.5.2),it do really support
adding several disks into a array (espacially raid5) to make the array
more large capability.

i want to know  if i want to add(not hotadd) a disk(or a partition) to
this array ,how can i make an reshape command correctly?
i have read the help of mdadm ,but i still can't find the correct
command format!
    please  do me a favor!
     thank you !
                                                                        dragon
