From: Joe Pruett <joey@q7.com>
Subject: Re: What is the logic behind 'Device or resource busy' ?
Date: Mon, 26 May 2003 17:39:45 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0305261738440.19678-100000@q7.q7.com>
References: <20030527015918.047bf247.pegasus@telemach.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030527015918.047bf247.pegasus@telemach.net>
To: Jure Pecar <pegasus@telemach.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i don't know the mdadm equivalent, but i do raidhotremove followed by 
raidhotadd to get around that issue.  if you look at /proc/mdstat after 
the failure, you'll probably see the drive is still part of the array, but 
just marked as down.  raidhotremove tells the system it is gone and then 
you can add it back.

