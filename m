From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: Grub vs Lilo
Date: Thu, 27 Jul 2006 23:16:20 +1000
Message-ID: <200607272316.23441.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

Wondering if anyone can comment on an easy way to get grub to update all 
components in a raid1 array.  I have a raid1 /boot with a raid10 /root and 
have previously used lilo with the raid-extra-boot option to install to boot 
sectors of all component devices.  With grub it appears that you can only 
update non default devices via the command line.  I like the ability to be 
able to type lilo and have all updated in one hit.  Is there a way to do this 
with grub?  

Cheers,

Lewis
