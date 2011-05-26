From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can not start md0 after upgrade. SOLVED
Date: Thu, 26 May 2011 13:38:32 -0500
Message-ID: <4DDE9E28.2020508@hardwarefreak.com>
References: <201105250819.27372.johnm@advocap.org> <201105251521.15679.johnm@advocap.org> <4DDD7B52.2060800@hardwarefreak.com> <201105261320.08844.johnm@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105261320.08844.johnm@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/26/2011 1:20 PM, John McMonagle wrote:
> On Wednesday, May 25, 2011 04:57:38 pm Stan Hoeppner wrote:

>> Please show the contents of /etc/mdadm.conf, and dmesg output.
> 
> The problem was it was starting mdadm before the scsi driver was done 
> initializing.
> 
> Found solution at http://wiki.debian.org/InitramfsDebug
> Added kernel parameter scsi_mod.scan=sync 
> 
> Ran in to this years ago but forgot :-(

Glad to hear you resolved it.  Is it safe to assume that taking a peek
at dmesg was useful?

-- 
Stan
