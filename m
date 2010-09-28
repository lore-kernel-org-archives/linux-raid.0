From: Tim Small <tim@seoss.co.uk>
Subject: Re: Debian kernel stanza after aptitude kernel upgrade
Date: Tue, 28 Sep 2010 12:11:35 +0100
Message-ID: <4CA1CD67.4040700@seoss.co.uk>
References: <30D96C04B1444C569D53B7790707D718@DesktopManie>	<4C98CCCD.80101@seoss.co.uk> <20100922062946.7e56d1d1@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100922062946.7e56d1d1@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "A. Krijgsman" <a.krijgsman@draftsman.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/09/10 21:29, Neil Brown wrote:
>> I think you need to stick the output of
>>
>> mdadm --examine --scan
>>
>> into /etc/mdadm/mdadm.conf
>>      
> It is generally better to use
>      mdadm --detail --scan
>
> for generating mdadm.conf as it is more likely to get the device names
> right.  And when doing this by hand, always review the output to make sure it
> looks right.
>    


Thanks for that Neil - Debian (and thus Ubuntu) currently uses the 
output of "mdadm --examine --scan --config=partitions" when 
autogenerating the mdadm.conf output.  Should this be considered a bug?  
If so, could you give a bit of detail, and I'll open a bug for the 
script....

Thanks,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

