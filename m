From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Linear mode: array size is less than sum of sizes
Date: Tue, 05 Jan 2010 20:13:18 +0000
Message-ID: <4B439D5E.2010107@anonymous.org.uk>
References: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com> <4B439BC8.1030908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B439BC8.1030908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Alessandro Baretta <alexbaretta@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/01/2010 20:06, John Robinson wrote:
> On 05/01/2010 18:21, Alessandro Baretta wrote:
>> Hi guys.
>>
>> I have a bizarre problem. Hopefully someone will provide some insight.
> [...]
>> As you can see the computed size is 67 sectors less than the reported
>> size. What happened to those sectors?
> 
> At the very least md linear mode will round down the constituent devices 
[...]

Try playing with dm instead of md - `man dmsetup` suggests it may be 
able to do a linear concatenation in single-sector amounts...

Cheers,

John.

