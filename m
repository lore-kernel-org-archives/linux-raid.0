From: "Norm Legit" <normlegit@gmail.com>
Subject: Question regarding superblocks
Date: Sun, 27 Aug 2006 18:52:03 -0700
Message-ID: <e5b4df2e0608271852u46801d69t45276527aa4e464d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I created a raid5 array with 3 devices.  Unfortunately, I carelessly
used the "--zero-superblock" option with mdadm to remove all of the
superblock.  I still have the mdadm.conf file which has the uuid in
it.  Is there a way for me to rebuild the superblocks or recover the
data on these drives?  Thanks,

-  Norm
