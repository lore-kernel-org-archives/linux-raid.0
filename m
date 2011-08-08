From: Joe Landman <joe.landman@gmail.com>
Subject: Re: 20 drive raid-10, CentOS5.5, after reboot assemble fails - all
 drives "non-fresh"
Date: Mon, 08 Aug 2011 12:17:48 -0400
Message-ID: <4E400C2C.8010402@gmail.com>
References: <4E3F4BD0.5060807@aeoncomputing.com> <20110808125608.7ceeaa02@notabene.brown> <4E3F66F2.3030300@aeoncomputing.com> <4E3F68CB.4060005@gmail.com> <4E3F6C07.8040106@aeoncomputing.com> <4E3F6E4D.1010502@gmail.com> <4E3F7A49.9000803@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3F7A49.9000803@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/08/2011 01:55 AM, Jeff Johnson wrote:
> Joe / et-al,
>
> The '--assemble --update=uuid' appears to have done the trick. It is
> weird because the uuid in the config file matched the uuid of the raid
> volume shown with 'mdadm -D /dev/md3' and the uuid on each of the drives
> shown with 'mdadm -E /dev/sdc1'

Interesting.

>
> The '--update=summaries' did not work. Assigning a new random uuid
> appears to have repaired whatever bit in the superblock was mucked up.
>
> Strange...
>
> Joe, thanks for your help. Find me at SC11, I'm buying you beers.
>

:)  see you there




-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
