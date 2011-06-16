From: Mike Power <mpower@dodtsair.com>
Subject: Re: mdadm and disk failures
Date: Thu, 16 Jun 2011 08:34:52 -0700
Message-ID: <4DFA229C.1080404@dodtsair.com>
References: <4DF97A7B.1070901@dodtsair.com> <20110616105908.474d22bc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616105908.474d22bc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ahh I understand more clearly now.  Because the failing drive will 
report an IO error the raid system can respond reactively by getting the 
data else where and writing it to the failing disk.  Earlier I had 
thought that the raid system might periodically poll the disks to see 
what blocks were lost and correct them.

This makes me much more interested in setting up a raid system above and 
beyond the performance benefit.
