From: Jaap Crezee <jaap@jcz.nl>
Subject: Re: read errors corrected
Date: Sun, 16 Jan 2011 09:33:25 +0100
Message-ID: <4D32AD55.1040502@jcz.nl>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com> <4D1C5B4F.8050506@texsoft.it> <AANLkTimm6P=Lb1uzC83Va323V+Q0e1xSzFfuc2ze-8Fp@mail.gmail.com> <4D318C46.7060204@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D318C46.7060204@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/15/11 13:00, Giovanni Tessore wrote:
> On 12/30/2010 05:41 PM, James wrote:
> As I know, Reallocated_Sector_Ct is the most meaningful SMART parameter related
> to disk sectors health.
> Also check for Current_Pending_Sector (sector that gave read on error and has
> not been reallocated yet).
> The values of your disks seems quite safe at the moment.
> Be proactive if the value grows in short time.

I wouldn't be too happy with more than 0 relocated- and/or pending sectors:
I replace these disks at once. Never had any problems with warranty about more 
then 0 sectors relocated. It seems manufacturers use the same values....

regards,

Jaap Crezee
