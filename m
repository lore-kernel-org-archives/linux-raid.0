From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 04 Jun 2013 11:38:57 -0700
Message-ID: <51AE3441.3000208@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com> <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com> <yq18v2prbum.fsf@sermon.lab.mkp.net> <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/2013 11:32 AM, Dan Williams wrote:
> On Tue, Jun 4, 2013 at 11:04 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
>>
>> hpa> One subdevice accepts it and the other doesn't, presumably.
>>
>> Ah. Well fail the command and let the block layer deal with it. This is
>> really no different from the discard case.
> 
> Which md also does not handle if the device later returns "illegal
> request" to a discard command.  My point about one device accepting
> the write and another device dropping it is we now have an
> inconsistent array and a write command to complete.  So I don't see
> how md can wait/trust that the upper layer will retry and fix things
> up?    Translate and retry internally for these command types, return
> success to the original request, and disable future requests.
> 

Well, if that is what the block device layer is defined to do then that
is what the block layer does.  It makes sense from the point of view of
a disk, there block layer has to translate and redo, so if the block
layer is defined to do that, why not rely on it?

	-hpa

