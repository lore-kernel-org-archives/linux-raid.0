From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: RAID 1 metadata - keep separate from mirror disks ?
Date: Wed, 11 Feb 2015 04:14:53 -0800 (PST)
Message-ID: <79c7cd53-bb6c-4058-95ad-7ebd56cf1056@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi There, 

On the RAID 1  metadata: is there  any way to keep the metadata separate from the mirror disks?  Could you  guide us on this ?, please. In general, we need to keep all metadata off the device itself, leaving all the device available for user data. This is particularly important in the migration case, where we want to take an existing LUN and add a second leg to it to create the mirror device without changing any of the data or metadata on the LUN. 

Thanks
/Suresh
