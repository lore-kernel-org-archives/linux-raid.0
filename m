From: Cory Coager <ccoager@gmail.com>
Subject: support for external persistent cache
Date: Tue, 18 Jan 2011 22:06:57 -0500
Message-ID: <4D365551.7090207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was wondering if it would be possible to add support for specifying a 
device to use for read/write persistent cache.  The reason why I'm 
asking is because I see physical ram disks with battery backups 
available recently.  These ram disks are relatively cheap and could add 
great performance for write through without the fear of data loss.

Any interest in adding support for this?
