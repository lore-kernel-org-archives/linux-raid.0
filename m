From: Philip Molter <philip@corp.texas.net>
Subject: IO scheduler choice?
Date: Mon, 04 Oct 2004 15:37:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4161B4A6.9060302@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Under 2.6, which I/O scheduler is best to use with software RAID?  There 
was some discussion early last week on kerneltrap about how the noop 
scheduler might be better for large RAID1s.  The noop scheduler is 
certainly better for hardware RAID in my limited testing.  Does anyone 
have any idea which scheduler is best for high load RAID 1, RAID 1+0 and 
RAID5 environments under software RAID?
